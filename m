Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0236D29E16
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 13:02:56 -0600 (CST)
Message-ID: <528A647C.7040603@sgi.com>
Date: Mon, 18 Nov 2013 13:03:24 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs_fsr: fix SWAPEXT failures under selinux
References: <5261B11F.1040000@redhat.com> <5261B67A.6000109@redhat.com>
In-Reply-To: <5261B67A.6000109@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

This has been committed.

Thanks
--Rich

commit 1adfe5c6296d3ea6c182f31a6728fc94af9146f7
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Oct 18 22:30:18 2013 +0000

     xfs_fsr: fix SWAPEXT failures under selinux

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
