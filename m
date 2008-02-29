Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 20:12:09 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1T4Bx1v022003
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 20:12:02 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE846EF05C6
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 20:12:27 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id pbRRtZU68nDc4Els for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 20:12:27 -0800 (PST)
Message-ID: <47C78629.104@sandeen.net>
Date: Thu, 28 Feb 2008 22:12:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc4
References: <20080229035000.7B24058C4C0F@chook.melbourne.sgi.com>
In-Reply-To: <20080229035000.7B24058C4C0F@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> 
> This will update the following files:
> 
>  fs/xfs/linux-2.6/xfs_super.c |   14 +++++++-------
>  fs/xfs/xfs_clnt.h            |    2 +-
>  fs/xfs/xfs_ialloc.c          |    2 +-
>  fs/xfs/xfs_mount.h           |    2 +-
>  fs/xfs/xfs_vfsops.c          |    4 ++--
>  5 files changed, 12 insertions(+), 12 deletions(-)
> 
> through these commits:
> 
> commit b7405bb65a83e819dd3b21a6d9636c279d9ce79a
> Author: Niv Sardi <xaiki@sgi.com>

um, I thought Jeff wrote that patch.

-Eric
