Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 19:59:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3L2x126020958
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 19:59:02 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C331A68137
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 19:59:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id EDDT21HDWbTCcxq3 for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 19:59:42 -0700 (PDT)
Message-ID: <480C031B.6010802@sandeen.net>
Date: Sun, 20 Apr 2008 21:59:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.26-rc1
References: <20080418050547.0E70F58C4C15@chook.melbourne.sgi.com> <20080420190515.GA19219@infradead.org> <480BFE97.9090008@sgi.com>
In-Reply-To: <480BFE97.9090008@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, akpm@linux-foundation.org

Lachlan McIlroy wrote:
> What were they?

[PATCH, mainline-only] remove sendfile leftovers
[PATCH, mainline-only] remove dmapi cruft in xfs_file.c
[PATCH, mainline-only] allow enabling CONFIG_XFS_DEBUG

-Eric

> Christoph Hellwig wrote:
>> On Fri, Apr 18, 2008 at 03:05:46PM +1000, Lachlan McIlroy wrote:
>>> Please pull from the for-linus branch:
>>>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
>>>
>>> This will update the following files:
>> Seems like you forgot the three mainline-only patches I sent a while
>> ago.
