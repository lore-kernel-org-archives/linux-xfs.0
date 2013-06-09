Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3AF7E29DF8
	for <xfs@oss.sgi.com>; Sun,  9 Jun 2013 05:46:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28B3F304032
	for <xfs@oss.sgi.com>; Sun,  9 Jun 2013 03:46:26 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id sHdzZCbP0yQQgMgk
	for <xfs@oss.sgi.com>; Sun, 09 Jun 2013 03:46:25 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 106FD6C177
	for <xfs@oss.sgi.com>; Sun,  9 Jun 2013 05:46:25 -0500 (CDT)
Message-ID: <51B45CFD.20500@hardwarefreak.com>
Date: Sun, 09 Jun 2013 05:46:21 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: attack upon XFS, misinformation abounds, linux-raid list
Reply-To: stan@hardwarefreak.com
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

In a recent linux-raid list thread here:
http://marc.info/?l=linux-raid&m=137072140106867&w=2

seriously flawed arguments against the reliability of XFS, and even the
performance of XFS, are made.  The OP even quotes Dave's LCA
presentation as a performance reason to avoid XFS.  The party really
gets started at paragraph 7.

I made a brief effort to debunk his claims and explained that he can't
have O_PONIES, that he should use fsync or O_DIRECT, etc for data
safety.  To non experts/advanced filesystem users, his long winded
argument may be persuasive.  Obviously none of you experts has time to
debunk every such post, but this one may be worth a read at least,
especially given the weight Google gives to vger lists.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
