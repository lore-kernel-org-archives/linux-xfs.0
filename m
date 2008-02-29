Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 16:47:24 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1T0l9If009652
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 16:47:13 -0800
Received: from mail.sceen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56E7762C572
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 16:47:36 -0800 (PST)
Received: from mail.sceen.net (sceen.net [213.41.243.68]) by cuda.sgi.com with ESMTP id EiiHYnH1xAQIdajl for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 16:47:36 -0800 (PST)
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: TAKE 977771 -
References: <20080228003236.9050858C4C0F@chook.melbourne.sgi.com>
	<47C72FC5.7030908@sandeen.net>
Date: Fri, 29 Feb 2008 11:47:05 +1100
In-Reply-To: <47C72FC5.7030908@sandeen.net> (Eric Sandeen's message of "Thu,
	28 Feb 2008 16:03:49 -0600")
Message-ID: <ncchcfsk2ra.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Niv Sardi-Altivanik <xaiki@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com, Lachlan McIlroy <lachlan@sgi.com>

Eric Sandeen <sandeen@sandeen.net> writes:

> Niv Sardi-Altivanik wrote:
>> If you mount an XFS filesystem with no mount options at all, then
>> the "ikeep" option is set rather than "noikeep".
>
> Thanks for getting this in.
>
> 2 questions...
>
> Is it going to make 2.6.25?

I hope so, but as I've been told to stay away from git trees it's in
lachlan's (over-busy) hands.

> And can you add a little text description to your subject line, for
> those doing inbox searches for things?  :)

Yep, sorry, I thought our tools were not that d^W^W^Wsmarter than they
are.

Cheers,
-- 
Niv Sardi
