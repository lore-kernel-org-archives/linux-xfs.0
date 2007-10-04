Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Oct 2007 17:26:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l940QId5013343
	for <xfs@oss.sgi.com>; Wed, 3 Oct 2007 17:26:20 -0700
Date: Thu, 4 Oct 2007 10:26:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
Message-ID: <20071004002611.GB23367404@sgi.com>
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com> <4700EE2A.1020304@sandeen.net> <4701A1D0.5010709@sgi.com> <4701ED51.8050706@sgi.com> <Pine.LNX.4.64.0710020442540.24427@p34.internal.lan> <4702F517.3040502@sgi.com> <Pine.LNX.4.64.0710030411250.3650@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710030411250.3650@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Timothy Shimmin <tes@sgi.com>, Lachlan McIlroy <lachlan@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Oct 03, 2007 at 04:11:50AM -0400, Justin Piszcz wrote:
> If one with was running 2.6.23-rc8 with XFS, does that mean we should run 
> xfs_repair on our filesystems after upgrading to -rc9?

Only if you had unclean shutdowns while running 2.6.23-rc8.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
