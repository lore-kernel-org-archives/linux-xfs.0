Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F5347F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:26:23 -0500 (CDT)
Message-ID: <52616F3A.8030906@sgi.com>
Date: Fri, 18 Oct 2013 12:26:18 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: remove incorrect l_sectBBsize assignment in
	xfs_repair
References: <5252F0D4.8090209@redhat.com>
In-Reply-To: <5252F0D4.8090209@redhat.com>
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
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>

This has been committed.

Thanks
--Rich

commit 5425725c56bccb9a91847cb74cfdadc8b44fecf7
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Oct 7 17:35:16 2013 +0000

     xfsprogs: remove incorrect l_sectBBsize assignment in xfs_repair

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
