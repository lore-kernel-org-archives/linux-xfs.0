Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 20:50:49 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1T4oWvA029165
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 20:50:38 -0800
Message-ID: <47C79078.4070504@sgi.com>
Date: Fri, 29 Feb 2008 15:56:24 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc4
References: <20080229035000.7B24058C4C0F@chook.melbourne.sgi.com> <47C78629.104@sandeen.net>
In-Reply-To: <47C78629.104@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> Please pull from the for-linus branch:
>>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
>>
>> This will update the following files:
>>
>>  fs/xfs/linux-2.6/xfs_super.c |   14 +++++++-------
>>  fs/xfs/xfs_clnt.h            |    2 +-
>>  fs/xfs/xfs_ialloc.c          |    2 +-
>>  fs/xfs/xfs_mount.h           |    2 +-
>>  fs/xfs/xfs_vfsops.c          |    4 ++--
>>  5 files changed, 12 insertions(+), 12 deletions(-)
>>
>> through these commits:
>>
>> commit b7405bb65a83e819dd3b21a6d9636c279d9ce79a
>> Author: Niv Sardi <xaiki@sgi.com>
> 
> um, I thought Jeff wrote that patch.

I'm sure he did too.  Every now and then our ptools -> git merge tools stuff up.
