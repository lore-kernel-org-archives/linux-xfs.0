Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02CF77F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:29:44 -0500 (CDT)
Message-ID: <526161F1.9070604@sgi.com>
Date: Fri, 18 Oct 2013 11:29:37 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: avoid array overflow in pf_batch_read()
References: <522017A4.8060400@redhat.com>
In-Reply-To: <522017A4.8060400@redhat.com>
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

commit e49f30a76f5e910092bd285ebef3f7641a09ec2e
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Aug 30 03:55:16 2013 +0000

     xfsprogs: avoid array overflow in pf_batch_read()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
