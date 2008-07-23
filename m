Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 22:00:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N4xuoK023882
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:59:57 -0700
Message-ID: <4886BB09.3080400@sgi.com>
Date: Wed, 23 Jul 2008 15:00:57 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com> <4886A9A3.8090805@sandeen.net> <4886ADB6.5060109@sgi.com> <4886AF06.40808@sandeen.net>
In-Reply-To: <4886AF06.40808@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com



Eric Sandeen wrote:
> Mark Goodwin wrote:
> 
>> As above, just run QA for cleanups.
> 
> Out of curiosity, will you trust this?  You'll run QA anyway, right?

yes we run it anyway, so maybe this (as a requirement) is overkill.

> And do you very often find errors in submitted patches by running QA?
> 

don't know, but it is part of the review process. For cleanups,
bugs/regressions seem to be fairly rare (hence they're subtle and
unexpected). I think you found one such regression a while back,
(after a herculean effort).

Cheers
-- Mark
