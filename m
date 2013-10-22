Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 223907F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 16:26:51 -0500 (CDT)
Message-ID: <5266ED97.1020308@sgi.com>
Date: Tue, 22 Oct 2013 16:26:47 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: stat the dev we're removing to make sure its'
	really gone V3
References: <1382372033-2742-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382372033-2742-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, sandeen@redhat.com

This has been committed.

Thanks
--Rich

commit 22ebe357198ea2519af6fd7e9082b9ac432631de
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Mon Oct 21 16:13:53 2013 +0000

     xfstests: stat the dev we're removing to make sure its' really gone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
