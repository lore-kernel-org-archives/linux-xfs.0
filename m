Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7247B7F58
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 08:03:49 -0600 (CST)
Message-ID: <52823550.30107@sgi.com>
Date: Tue, 12 Nov 2013 08:04:00 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH RESEND] xfstests: fix compile error of src/fssum.c on
	bigendian host
References: <1384229813-30532-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1384229813-30532-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

This has been committed.

Thanks
--Rich

commit 3d2a446df422c5a1b9ab561ae73e66b68a5aa4c3
Author: Eryu Guan <eguan@redhat.com>
Date:   Tue Nov 12 04:16:53 2013 +0000

     xfstests: fix compile error of src/fssum.c on bigendian host

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
