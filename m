Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 23:54:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L6s2lA008844
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 23:54:04 -0700
Message-ID: <480C3A41.6020809@sgi.com>
Date: Mon, 21 Apr 2008 16:54:57 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.26-rc1
References: <20080418050547.0E70F58C4C15@chook.melbourne.sgi.com> <20080420190515.GA19219@infradead.org> <480BFE97.9090008@sgi.com> <480C031B.6010802@sandeen.net>
In-Reply-To: <480C031B.6010802@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, akpm@linux-foundation.org

Thanks Eric.  I'll include them in the next update.

Eric Sandeen wrote:
> Lachlan McIlroy wrote:
>> What were they?
> 
> [PATCH, mainline-only] remove sendfile leftovers
> [PATCH, mainline-only] remove dmapi cruft in xfs_file.c
> [PATCH, mainline-only] allow enabling CONFIG_XFS_DEBUG
> 
> -Eric
> 
>> Christoph Hellwig wrote:
>>> On Fri, Apr 18, 2008 at 03:05:46PM +1000, Lachlan McIlroy wrote:
>>>> Please pull from the for-linus branch:
>>>>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
>>>>
>>>> This will update the following files:
>>> Seems like you forgot the three mainline-only patches I sent a while
>>> ago.
> 
> 
> 
