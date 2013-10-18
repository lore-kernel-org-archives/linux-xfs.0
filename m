Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9AA537F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:18:35 -0500 (CDT)
Message-ID: <52616D67.7090307@sgi.com>
Date: Fri, 18 Oct 2013 12:18:31 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: handle symlinks etc in
	fs_table_initialise_mounts()
References: <5249AE5F.30305@redhat.com>
In-Reply-To: <5249AE5F.30305@redhat.com>
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
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

This has been committed.

Thanks
--Rich

commit 050a7f1f79314470c18e9d11c28daf75dd959830
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Sep 30 17:01:19 2013 +0000

     xfsprogs: handle symlinks etc in fs_table_initialise_mounts()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
