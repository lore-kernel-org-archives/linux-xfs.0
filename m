Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7AA3D7F37
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 08:57:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60B7F304071
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 06:57:37 -0700 (PDT)
Received: from bp-05.lab.msp.redhat.com (nat-pool-rdu.redhat.com
	[66.187.233.202]) by cuda.sgi.com with ESMTP id
	d09RG6dKWnD1g5sZ for <xfs@oss.sgi.com>;
	Wed, 13 Mar 2013 06:57:36 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/3] xfstests patches
Date: Wed, 13 Mar 2013 09:57:00 -0500
Message-Id: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

2 pretty simple ones, and a new btrfs test

[PATCH 1/3] xfstests: add 274 to the prealloc group
[PATCH 2/3] xfstests: keep newlines out of SCRATCH_DEV_POOL
[PATCH 3/3] xfstests: btrfs tests for basic informational commands

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
