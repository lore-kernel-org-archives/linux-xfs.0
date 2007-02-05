Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Feb 2007 14:38:53 -0800 (PST)
Received: from pne-smtpout3-sn1.fre.skanova.net (pne-smtpout3-sn1.fre.skanova.net [81.228.11.120])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l15Mcf3c014086
	for <xfs@oss.sgi.com>; Mon, 5 Feb 2007 14:38:45 -0800
Received: from safari.iki.fi (80.223.106.128) by pne-smtpout3-sn1.fre.skanova.net (7.2.075)
        id 45AE1FD5001033AC for xfs@oss.sgi.com; Mon, 5 Feb 2007 22:29:06 +0100
Date: Mon, 5 Feb 2007 23:29:06 +0200
From: Sami Farin <safari-xfs@safari.iki.fi>
Subject: Re: Spam on list?
Message-ID: <20070205212906.GA6096@m.safari.iki.fi>
References: <Pine.LNX.4.64.0702040822520.14035@p34.internal.lan> <p73wt2wnbd2.fsf@bingen.suse.de> <68c491a60702050352t278e8381l72795ed9ea880029@mail.gmail.com> <200702051306.34279.ak@suse.de> <45C73CB9.5000402@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45C73CB9.5000402@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Feb 05, 2007 at 08:18:33 -0600, Eric Sandeen wrote:
> Andi Kleen wrote:
> >On Monday 05 February 2007 12:52, Martin Schröder wrote:
> >>05 Feb 2007 11:32:25 +0100, Andi Kleen <ak@suse.de>:
> >>>Please don't do that. It means nothing can be cross posted
> >>>from l-k anymore, which would be pretty bad.
> >>Then set up a list admin who can approve such postings.
> >
> >That adds unacceptable latency. Also lists who spam senders
> >with bounce messages tend to be dropped quickly from cc lists.
> >
> >Also you couldn't list xfs@ as bug report address anymore because
> >bug report addresses must be available to everyone.
> >
> >In general it's a bad idea.
> >
> >-Andi
> >
> 
> Well, I agree w/ those arguments too, Andi.
> 
> I honestly don't know why oss seems to have so much more spam than, say, 
> LKML.  It is getting to a really bad level, and I sympathize with those 
> whose inboxes are bombarded, too.

Those 419 scams and phishes are caught by for example a bayesian filter.
That's what I have done since 2003.

As for the "only subscribers can post" as an anti-spam measure,
I can say that for those mailing lists where they are doing it,
the emails from non-subscribers go to /dev/null and if you
contact owner, it goes, too, because you are not subscribed (!!)
OR they just tell you to screw off.  After waiting for a week.
If they feel like it.

This is not to say that xfs ml would be doing this /dev/nulling ,
this is just my general feeling about this anti-spam measure
and its usability.  Besides, I use different (secret) subscription
email address for mailing lists than in the From header field
when I write to the list.  This way it's easy to have different
anti-spam measures for subscription email (e.g., none)
than for the email in From (e.g., I can reject out-of-office
notices and other brokeness).  If I had to use the same
email for both purposes, I couldn't for example reject
based on 419 scammers' IP addresses found in Received
etc. header fields because then I would get auto-unsubscribed
from this mailing list when ecartis thinks my email is broken.

-- 
Do what you love because life is too short for anything else.
