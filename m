Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C43D429E09
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 14:36:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A1E978F8050
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 12:36:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id o1v2m4F6NCQ2ohbL for <xfs@oss.sgi.com>;
	Tue, 23 Apr 2013 12:36:32 -0700 (PDT)
Message-ID: <5176E2C0.9080306@sandeen.net>
Date: Tue, 23 Apr 2013 14:36:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfsprogs: manpage spelling fixes
References: <5175BB8F.5090604@sandeen.net> <5175BC20.9010403@sandeen.net>
	<5176A639.5020703@sgi.com>
In-Reply-To: <5176A639.5020703@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/23/13 10:18 AM, Rich Johnston wrote:
> On 04/22/2013 05:39 PM, Eric Sandeen wrote:
>> Fix several spelling errors in xfsprogs manpages.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/man/man5/projects.5 b/man/man5/projects.5
> #rcj OK
> 
>> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> #rcj serialisation is misspelled, should be serialization.
> 
>> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> #rcj guarenteed should be guaranteed

whoops I missed that, didn't introduce it, did I?

> #rcj Nonleaf to Non-leaf ???? not sure about that one :)

$ aspell -a
@(#) International Ispell Version 3.1.20 (but really Aspell 0.60.6)
nonleaf
& nonleaf 11 0: non leaf, non-leaf, ...

*shrug*

-Eric

>> diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
> #rcj OK
> 
>> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> #rcj OK
> 
>> diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
> #rcj OK
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
