/**
 * bot-sentry
 *
 * bot-sentry is the legal property of its developers.  Please refer to the
 * AUTHORS file distributed with this source distribution.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
 * Place, Suite 330, Boston, MA  02111-1307  USA
 */

/**
 * config.h
 */
#ifdef HAVE_CONFIG_H
#   include "config.h"
#endif

/**
 * system headers
 */
#include <glib.h>

#ifndef G_GNUC_NULL_TERMINATED
#  if __GNUC__ >= 4
#    define G_GNUC_NULL_TERMINATED __attribute__((__sentinel__))
#  else
#    define G_GNUC_NULL_TERMINATED
#  endif                        /* __GNUC__ >= 4 */
#endif                          /* G_GNUC_NULL_TERMINATED */

/**
 * gettext
 */
#ifdef ENABLE_NLS
#   include <glib/gi18n-lib.h>
#else
#   define _(String) ((const char *) (String))
#endif                          /* ENABLE_NLS */

/**
 * purple headers for most plugins
 */
#include <plugin.h>
#include <version.h>

/**
 * purple headers for this plugin
 */
#include <util.h>
#include <debug.h>
#include <account.h>
#include <accountopt.h>
#include <privacy.h>

#ifdef _WIN32
#   include <win32dep.h>
#endif

#define PLUGIN_ID "core-deckrider-" PACKAGE

/**
 * Declare the list of struct that is used to store the first
 * message that a member sends for later delivery if he meets
 * the challenge.
 */
typedef struct _PendingMessage PendingMessage;
struct _PendingMessage
{
    glong tv_sec;
    char *protocol_id;
    char *username;
    char *sender;
    char *message;
};
static GSList *pending_list = NULL;     /* GSList of PendingMessage */

static guint callback_id;

enum auth_choice
{
    auth_choice_DENY = -1,
    auth_choice_PROMPT = 0,
    auth_choice_GRANT = 1
};

/**
 * Return TRUE if the protocol_ids match
 */
static gboolean
protocmp(
    PurpleAccount * account,
    const PendingMessage * pending)
{
    if (!purple_utf8_strcasecmp(pending->protocol_id, account->protocol_id)) {
        return TRUE;
    } else {
        return FALSE;
    }
}

/**
 * Return TRUE if the usernames match
 */
static gboolean
usercmp(
    PurpleAccount * account,
    const PendingMessage * pending)
{
    if (!purple_utf8_strcasecmp(pending->username, account->username)) {
        return TRUE;
    } else {
        return FALSE;
    }
}

/**
 * Return TRUE if the unknown sender names match
 */
static gboolean
sendercmp(
    const char *sender,
    const PendingMessage * pending)
{
    if (!purple_utf8_strcasecmp(pending->sender, sender)) {
        return TRUE;
    } else {
        return FALSE;
    }
}

/**
 * Free an entry in the pending_list.  Don't free the message field
 * unless free_message = TRUE
 */
static void
free_pending(
    GSList * entry,
    gboolean free_message)
{
    PendingMessage *pending = entry->data;
    g_free(pending->protocol_id);
    g_free(pending->username);
    g_free(pending->sender);
    if (free_message) {
        g_free(pending->message);
    }
    g_free(pending);
    pending_list = g_slist_remove_link(pending_list, entry);
}

/**
 * Purge pending_list of entries older than the defined minutes limit
 */
static void
expire_pending_list(
    )
{
    const glong max_min = purple_prefs_get_int("/plugins/core/" PLUGIN_ID "/botmaxminutes");
    const glong max_sec = 60 * max_min;
    GTimeVal *now = NULL;
    GSList *search = NULL;
    now = g_new0(GTimeVal, 1);
    g_get_current_time(now);
    for (search = pending_list; search; search = search->next) {
        PendingMessage *pending = search->data;
        if (pending->tv_sec < (now->tv_sec - max_sec)) {
            free_pending(search, TRUE);
        }
    }
    g_free(now);
}

/**
 * Print the contents of pending_list to the debug log
 */
static void
debug_pending_list(
    )
{
    GSList *search = NULL;
    for (search = pending_list; search; search = search->next) {
        PendingMessage *pending = search->data;
        purple_debug_info(PACKAGE, _("Pending:  protocol = %s, username = %s, sender = %s, message = %s\n"), pending->protocol_id, pending->username, pending->sender, pending->message);
    }
}

static void
send_auto_reply(
    PurpleAccount * account,
    const char *recipient,
    const char *message)
{
    int i = 0;
    PurpleConnection *gc = NULL;
    PurplePluginProtocolInfo *prpl_info = NULL;

    gc = purple_account_get_connection(account);

    if (gc != NULL && gc->prpl != NULL) {
        prpl_info = PURPLE_PLUGIN_PROTOCOL_INFO(gc->prpl);
    }

    if (prpl_info && prpl_info->send_im) {
        i = prpl_info->send_im(gc, recipient, message, PURPLE_MESSAGE_AUTO_RESP);
    }

    return;
}

/**
 * The psychic plugin conflicts with bot sentry
 * unless buddies_only is set to true.
 */
static void
fix_psychic_settings(
    )
{
    if (!purple_prefs_get_bool("/plugins/core/psychic/buddies_only")) {
        purple_prefs_set_bool("/plugins/core/psychic/buddies_only", TRUE);
        purple_notify_info(NULL, _("Preference Change"), _("Your preferences have been changed to only enable Psychic Mode for users on your buddy list."), _("This setting is required while the Bot Sentry plugin is enabled."));
    }
}

static void
plugin_load_cb(
    PurplePlugin * plugin)
{
    if (!purple_utf8_strcasecmp(purple_plugin_get_id(plugin), "core-psychic")) {
        fix_psychic_settings();
    }
}

void
plugin_prefs_cb(
    const char *name,
    PurplePrefType type,
    gconstpointer val,
    gpointer data)
{
    fix_psychic_settings();
}

#if ( PURPLE_MAJOR_VERSION == 2 && PURPLE_MINOR_VERSION >= 3 ) || PURPLE_MAJOR_VERSION > 2
/**
 * This is our callback for the account-authorization-requested signal.
 *
 * We return the auth_policy preference
 */
static int
account_authorization_requested_cb(
    PurpleAccount * account,
    const char *user,
    gpointer data)
{
    GSList *slist = NULL;
    gint auth_policy = purple_prefs_get_int("/plugins/core/" PLUGIN_ID "/auth_policy");

    /**
     * bot sentry may not be desired for authorizations
     */
    if (auth_choice_PROMPT == auth_policy) {
        return auth_policy;
    }

    /**
     * bot sentry may not be desired for this account
     */
    if (!purple_account_get_bool(account, PLUGIN_ID "-enabled", TRUE)) {
        return auth_choice_PROMPT;
    }

    /**
     * don't auto-deny when there is already an open conversation
     */
    if (purple_find_conversation_with_account(PURPLE_CONV_TYPE_IM, user, account)) {
        if (auth_choice_DENY == auth_policy) {
            return auth_choice_PROMPT;
        } else {
            purple_debug_info(PACKAGE, _("GRANT account authorization to %s in open conversation using %s\n"), user, account->protocol_id);
            return auth_choice_GRANT;
        }
    }

    /**
     * don't auto-deny buddies
     */
    if (purple_find_buddy(account, user)) {
        if (auth_choice_DENY == auth_policy) {
            return auth_choice_PROMPT;
        } else {
            purple_debug_info(PACKAGE, _("GRANT account authorization to %s on buddy list using %s\n"), user, account->protocol_id);
            return auth_choice_GRANT;
        }
    }

    /**
     * don't auto-deny permit list members
     */
    for (slist = account->permit; slist != NULL; slist = slist->next) {
        if (!purple_utf8_strcasecmp(user, purple_normalize(account, (char *) slist->data))) {
            if (auth_choice_DENY == auth_policy) {
                return auth_choice_PROMPT;
            } else {
                purple_debug_info(PACKAGE, _("GRANT account authorization to %s on permit list using %s\n"), user, account->protocol_id);
                return auth_choice_GRANT;
            }
        }
    }

    /**
     *  don't grant/prompt deny list members
     */
    for (slist = account->deny; slist != NULL; slist = slist->next) {
        if (!purple_utf8_strcasecmp(user, purple_normalize(account, (char *) slist->data))) {
            purple_debug_info(PACKAGE, _("DENY account authorization to %s on deny list using %s\n"), user, account->protocol_id);
            return auth_choice_DENY;
        }
    }

    /**
     * return the user's auth request setting
     */
    if (auth_choice_DENY == auth_policy) {
        purple_debug_info(PACKAGE, _("DENY account authorization to %s using %s\n"), user, account->protocol_id);
    }
    if (auth_choice_GRANT == auth_policy) {
        purple_debug_info(PACKAGE, _("GRANT account authorization to %s using %s\n"), user, account->protocol_id);
    }
    return auth_policy;
}
#endif

/**
 * This is our callback for the receiving-im-msg signal.
 *
 * We return TRUE to block the IM, FALSE to accept the IM
 */
static gboolean
receiving_im_msg_cb(
    PurpleAccount * account,
    char **sender,
    char **buffer,
    PurpleConversation * conv,
    PurpleMessageFlags * flags,
    void *data)
{
    gboolean retval = FALSE;    /* assume the sender is allowed */
    gboolean found = FALSE;
    gint pos = -1;
    char *botmsg = NULL;

    PendingMessage *pending = NULL;
    PurpleBuddy *buddy = NULL;
    PurpleGroup *group = NULL;
    GSList *slist = NULL;
    GSList *search = NULL;

    PurpleConnection *connection = NULL;

    const char *question = purple_prefs_get_string("/plugins/core/" PLUGIN_ID "/question");
    const char *answer = purple_prefs_get_string("/plugins/core/" PLUGIN_ID "/answer");
    const char *successmsg = purple_prefs_get_string("/plugins/core/" PLUGIN_ID "/successmsg");

    PendingMessage *newpend = NULL;

    /**
     * expire any old entries in pending
     */
    expire_pending_list();

    connection = purple_account_get_connection(account);

    /**
     * not good, but don't do anything
     */
    if (!connection || !sender) {
        return retval;
    }

    /**
     * bot sentry may not be desired for this account
     */
    if (!purple_account_get_bool(account, PLUGIN_ID "-enabled", TRUE)) {
        return retval;
    }

    /**
     * if there is already an open conversation, allow it
     */
    if (purple_find_conversation_with_account(PURPLE_CONV_TYPE_IM, *sender, account)) {
        return retval;
    }

    /**
     * don't make buddies use the challenge/response system
     */
    if (purple_find_buddy(account, *sender)) {
        return retval;
    }

    /**
     * don't make permit list members use the challenge/response system
     */
    for (slist = account->permit; slist != NULL; slist = slist->next) {
        if (!purple_utf8_strcasecmp(*sender, purple_normalize(account, (char *) slist->data))) {
            return retval;
        }
    }

    /**
     * if there is no question or no answer, allow the sender
     */
    if (!question || !answer) {
        return retval;
    }

    /**
     * blank / null message ... can this even happen?
     */
    if (!*buffer) {
        return retval;
    }

    /**
     * search if this sender is already in pending
     */
    for (search = pending_list; search; search = search->next) {
        pending = search->data;
        pos = g_slist_position(pending_list, search);

        if (protocmp(account, pending) && usercmp(account, pending)
            && sendercmp(*sender, pending)) {
            found = TRUE;
            break;
        }
    }

    if (!found) {
        /**
         * its the first time through, save the nick/msg to the
         * queue and ask the question
         */
        GTimeVal *now = NULL;
        now = g_new0(GTimeVal, 1);
        g_get_current_time(now);

        newpend = g_new0(PendingMessage, 1);
        newpend->tv_sec = now->tv_sec;
        newpend->protocol_id = g_strdup(account->protocol_id);
        newpend->username = g_strdup(account->username);
        newpend->sender = g_strdup(*sender);
        newpend->message = g_strdup(*buffer);
        pending_list = g_slist_prepend(pending_list, newpend);

        botmsg = g_strdup_printf("%s", question);

        send_auto_reply(account, *sender, botmsg);

        g_free(now);
        g_free(botmsg);
        retval = TRUE;
    } else {
        char *plain = purple_markup_strip_html(*buffer);
        if (purple_utf8_strcasecmp(plain, answer)) {
                /**
                 * Sorry, thanks for playing, please try again
                 */
            retval = TRUE;
        } else {
            botmsg = g_strdup_printf("%s", successmsg);
            send_auto_reply(account, *sender, botmsg);

            if (purple_prefs_get_bool("/plugins/core/" PLUGIN_ID "/auto_add_permit")) {
                if (!purple_privacy_permit_add(account, *sender, FALSE)) {
                    purple_debug_info(PACKAGE, _("Unable to add %s/%s/%s to permit list\n"), *sender, pending->username, pending->protocol_id);
                }
            }

            if (purple_prefs_get_bool("/plugins/core/" PLUGIN_ID "/auto_add_buddy")) {
                group = purple_group_new(_("Bot Sentry"));
                buddy = purple_buddy_new(account, *sender, NULL);
                if (group != NULL && buddy != NULL) {
                    purple_blist_add_buddy(buddy, NULL, group, NULL);
                } else {
                    purple_debug_info(PACKAGE, _("Unable to add %s/%s/%s to buddy list\n"), *sender, pending->username, pending->protocol_id);
                }
            }

            /**
             * Free what is currently in the buffer (the correct answer)
             * and replace it with the user's first message that was
             * queued, pending the correct answer.  I think some other
             * process is supposed to free the buffer after its sent.
             */
            g_free(*buffer);
            *buffer = pending->message;

            /**
             * Clean up everything else except pending->message
             */
            free_pending(search, FALSE);

            retval = FALSE;     /* Don't block this message */
        }
        g_free(plain);
    }
    debug_pending_list();
    return retval;              /* returning TRUE will block the IM */
}

static PurplePluginPrefFrame *
get_plugin_pref_frame(
    PurplePlugin * plugin)
{
    PurplePluginPrefFrame *frame;
    PurplePluginPref *ppref;

    frame = purple_plugin_pref_frame_new();

    ppref = purple_plugin_pref_new_with_label(_("Define the challenge (blank to disable):"));
    purple_plugin_pref_frame_add(frame, ppref);

    ppref = purple_plugin_pref_new_with_name_and_label("/plugins/core/" PLUGIN_ID "/question", _("Question"));
    purple_plugin_pref_frame_add(frame, ppref);

    ppref = purple_plugin_pref_new_with_name_and_label("/plugins/core/" PLUGIN_ID "/answer", _("Answer"));
    purple_plugin_pref_frame_add(frame, ppref);

    ppref = purple_plugin_pref_new_with_name_and_label("/plugins/core/" PLUGIN_ID "/successmsg", _("Success message"));
    purple_plugin_pref_frame_add(frame, ppref);

    ppref = purple_plugin_pref_new_with_name_and_label("/plugins/core/" PLUGIN_ID "/botmaxminutes", _("Time limit for answering (in minutes)"));
    purple_plugin_pref_set_bounds(ppref, 1, 9999);
    purple_plugin_pref_frame_add(frame, ppref);

    ppref = purple_plugin_pref_new_with_label(_("When the challenge is met, let this person IM me and:"));
    purple_plugin_pref_frame_add(frame, ppref);

    ppref = purple_plugin_pref_new_with_name_and_label("/plugins/core/" PLUGIN_ID "/auto_add_permit", _("Add this person to my Allow List"));
    purple_plugin_pref_frame_add(frame, ppref);

    ppref = purple_plugin_pref_new_with_name_and_label("/plugins/core/" PLUGIN_ID "/auto_add_buddy", _("Add this person to my Buddy List"));
    purple_plugin_pref_frame_add(frame, ppref);

#if ( PURPLE_MAJOR_VERSION == 2 && PURPLE_MINOR_VERSION >= 3 ) || PURPLE_MAJOR_VERSION > 2
    ppref = purple_plugin_pref_new_with_label(_("When a buddy authorization request is received:"));
    purple_plugin_pref_frame_add(frame, ppref);

    ppref = purple_plugin_pref_new_with_name_and_label("/plugins/core/" PLUGIN_ID "/auth_policy", _("Policy"));
    purple_plugin_pref_set_type(ppref, PURPLE_PLUGIN_PREF_CHOICE);
    purple_plugin_pref_add_choice(ppref, _("deny the request"), GINT_TO_POINTER(auth_choice_DENY));
    purple_plugin_pref_add_choice(ppref, _("ask me what to do"), GINT_TO_POINTER(auth_choice_PROMPT));
    purple_plugin_pref_add_choice(ppref, _("grant the request"), GINT_TO_POINTER(auth_choice_GRANT));
    purple_plugin_pref_frame_add(frame, ppref);
#endif

    return frame;
}

static PurplePluginUiInfo prefs_info = {
    get_plugin_pref_frame
};

static gboolean
plugin_load(
    PurplePlugin * plugin)
{
    GList *iter;
    PurplePlugin *prpl;
    PurplePluginProtocolInfo *prpl_info;
    PurpleAccountOption *option;

    purple_prefs_add_none("/plugins");
    purple_prefs_add_none("/plugins/core");
    purple_prefs_add_none("/plugins/core/" PLUGIN_ID);

    purple_prefs_add_string("/plugins/core/" PLUGIN_ID "/question", _("How do you spell the number 10?"));
    purple_prefs_add_string("/plugins/core/" PLUGIN_ID "/answer", _("ten"));

    purple_prefs_add_bool("/plugins/core/" PLUGIN_ID "/auto_add_permit", FALSE);
    purple_prefs_add_bool("/plugins/core/" PLUGIN_ID "/auto_add_buddy", FALSE);

#if ( PURPLE_MAJOR_VERSION == 2 && PURPLE_MINOR_VERSION >= 3 ) || PURPLE_MAJOR_VERSION > 2
    purple_prefs_add_int("/plugins/core/" PLUGIN_ID "/auth_policy", auth_choice_PROMPT);
#endif

    /* all new prefs must be created first */
    purple_prefs_rename("/plugins/core/gaim_bs", "/plugins/core/" PLUGIN_ID);
    purple_prefs_rename("/plugins/core/pidgin_bs", "/plugins/core/" PLUGIN_ID);

    purple_prefs_add_string("/plugins/core/" PLUGIN_ID "/successmsg", _("Thanks for your confirmation! You may now speak normally with me."));

    purple_prefs_add_int("/plugins/core/" PLUGIN_ID "/botmaxminutes", 10);

    /* enable bot sentry account by account */
    for (iter = purple_plugins_get_protocols(); iter; iter = iter->next) {
        prpl = iter->data;
        if (NULL == prpl) {
            return FALSE;
        }
        prpl_info = PURPLE_PLUGIN_PROTOCOL_INFO(prpl);
        if (NULL == prpl_info) {
            return FALSE;
        }
        option = purple_account_option_bool_new(_("Use Bot Sentry with this account"), PLUGIN_ID "-enabled", TRUE);
        prpl_info->protocol_options = g_list_append(prpl_info->protocol_options, option);
    }

    purple_signal_connect(purple_conversations_get_handle(), "receiving-im-msg", plugin, PURPLE_CALLBACK(receiving_im_msg_cb), NULL);

#if ( PURPLE_MAJOR_VERSION == 2 && PURPLE_MINOR_VERSION >= 3 ) || PURPLE_MAJOR_VERSION > 2
    purple_signal_connect(purple_accounts_get_handle(), "account-authorization-requested", plugin, PURPLE_CALLBACK(account_authorization_requested_cb), NULL);
#endif

    purple_signal_connect(purple_plugins_get_handle(), "plugin-load", plugin, PURPLE_CALLBACK(plugin_load_cb), NULL);

    callback_id = purple_prefs_connect_callback(purple_prefs_get_handle(), "/plugins/core/psychic/buddies_only", plugin_prefs_cb, NULL);

    fix_psychic_settings();

    return TRUE;
}

static gboolean
plugin_unload(
    PurplePlugin * plugin)
{
    PurplePluginProtocolInfo *prpl_info;
    GList *tmp = NULL;
    GList *popt_iter = NULL;
    GList *prpl_iter = NULL;
    GSList *pend_iter = NULL;

    purple_signals_disconnect_by_handle(plugin);
    purple_prefs_disconnect_callback(callback_id);

    for (pend_iter = pending_list; pend_iter; pend_iter = pend_iter->next) {
        free_pending(pend_iter, TRUE);
    }

    /* 
     * destroy/free bot sentry account prefs
     */
    for (prpl_iter = purple_plugins_get_protocols(); prpl_iter; prpl_iter = prpl_iter->next) {
        if (NULL == (PurplePlugin *) prpl_iter->data) {
            return FALSE;
        }
        prpl_info = PURPLE_PLUGIN_PROTOCOL_INFO((PurplePlugin *) prpl_iter->data);
        if (NULL == prpl_info) {
            return FALSE;
        }
        popt_iter = prpl_info->protocol_options;
        while (NULL != popt_iter) {
            tmp = popt_iter;
            popt_iter = g_list_next(popt_iter);
            if (g_str_has_prefix(purple_account_option_get_setting((PurpleAccountOption *) tmp->data), PLUGIN_ID "-")) {
                purple_account_option_destroy((PurpleAccountOption *)
                                              tmp->data);
                prpl_info->protocol_options = g_list_remove(prpl_info->protocol_options, tmp->data);
            }
        }
    }

    return TRUE;
}

static void
plugin_destroy(
    PurplePlugin * plugin)
{
    plugin_unload(plugin);
    return;
}

static PurplePluginInfo info = {
    PURPLE_PLUGIN_MAGIC,
    PURPLE_MAJOR_VERSION,
    0,
    PURPLE_PLUGIN_STANDARD,                               /**< type           */
    NULL,                                                 /**< ui_requirement */
    0,                                                    /**< flags          */
    NULL,                                                 /**< dependencies   */
    PURPLE_PRIORITY_DEFAULT,                              /**< priority       */

    PLUGIN_ID,                                            /**< id             */
    NULL,                                                 /**< name           */
    VERSION,                                              /**< version        */
    NULL,                                                 /**  summary        */
    NULL,                                                 /**  description    */
    "David Everly <deckrider@users.sourceforge.net>",     /**< author         */
    "http://github.com/jesobreira/bot-sentry",                                    /**< homepage       */

    plugin_load,                                          /**< load           */
    plugin_unload,                                        /**< unload         */
    plugin_destroy,                                       /**< destroy        */

    NULL,                                                 /**< ui_info        */
    NULL,                                                 /**< extra_info     */
    &prefs_info,                                          /**< prefs_info     */
    NULL
};

static void
init_plugin(
    PurplePlugin * plugin)
{
#ifdef ENABLE_NLS
    purple_debug_info(PACKAGE, "bindtextdomain = %s", bindtextdomain(GETTEXT_PACKAGE, LOCALEDIR));
    purple_debug_info(PACKAGE, "bind_textdomain_codeset = %s", bind_textdomain_codeset(GETTEXT_PACKAGE, "UTF-8"));
#endif                          /* ENABLE_NLS */

    info.name = (char *) _("Bot Sentry");
    info.summary = (char *) _("Block robots from sending Instant Messages");
    info.description = (char *)
        _("A simple challenge-response system to prevent spam-bots from sending you instant messages.  Think of it as a captcha and a pop-up blocker.  You define a question and an answer.  Instant messages from others will be ignored unless one of the following is true:\n\n\t* the sender is in your Buddy List\n\t* the sender is in your Allow List\n\t* the sender correctly answers your question\n\nOptionally, you may have the sender automatically added to your Allow List when the correct answer is provided.\n\nEncryption plugin users:  Bot Sentry will send plain text messages to the sender until the sender correctly answers your question.");

    return;
}

PURPLE_INIT_PLUGIN(PACKAGE, init_plugin, info)

/**
 * vim:tabstop=4:shiftwidth=4:expandtab:
 */
