Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 04:00:03 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94AxuAr002500
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 03:59:59 -0700
Date: Thu, 4 Oct 2007 06:59:57 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
In-Reply-To: <20071004002611.GB23367404@sgi.com>
Message-ID: <Pine.LNX.4.64.0710040659530.8275@p34.internal.lan>
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com>
 <4700EE2A.1020304@sandeen.net> <4701A1D0.5010709@sgi.com> <4701ED51.8050706@sgi.com>
 <Pine.LNX.4.64.0710020442540.24427@p34.internal.lan> <4702F517.3040502@sgi.com>
 <Pine.LNX.4.64.0710030411250.3650@p34.internal.lan> <20071004002611.GB23367404@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Lachlan McIlroy <lachlan@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



On Thu, 4 Oct 2007, David Chinner wrote:

> On Wed, Oct 03, 2007 at 04:11:50AM -0400, Justin Piszcz wrote:
>> If one with was running 2.6.23-rc8 with XFS, does that mean we should run
>> xfs_repair on our filesystems after upgrading to -rc9?
>
> Only if you had unclean shutdowns while running 2.6.23-rc8.
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
>

K, thanks.

Justin.
