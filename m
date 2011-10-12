Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9C4oAMx038906 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 23:50:10 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C9E71BE25D
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 21:50:08 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id d6tnVNjqRaEsXNf2 for
	<xfs@oss.sgi.com>; Tue, 11 Oct 2011 21:50:08 -0700 (PDT)
From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 0/3] xfstest patch
Date: Wed, 12 Oct 2011 12:52:51 +0800
Message-Id: <1318395174-4075-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <4E3BA2F7.4080500@oracle.com>
References: <4E3BA2F7.4080500@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: Anand Jain <Anand.Jain@oracle.com>, chris.mason@oracle.com

Anand Jain (3):
  263: Functional test case for the btrfs snapshot
  264: Functional test case for the btrfs de-fragmentation
  265: Functional test case for the btrfs raid operations

 263           |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 263.out       |    2 +
 264           |   60 ++++++++++++++++++
 264.out       |    2 +
 265           |  187 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 265.out       |    2 +
 README        |    7 ++-
 common.config |   14 ++++
 common.rc     |  122 ++++++++++++++++++++++++++++++++++++
 group         |    3 +
 10 files changed, 590 insertions(+), 1 deletions(-)
 create mode 100755 263
 create mode 100644 263.out
 create mode 100755 264
 create mode 100644 264.out
 create mode 100755 265
 create mode 100644 265.out

-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
