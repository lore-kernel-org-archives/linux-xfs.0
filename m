Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7F7EC7F3F
	for <xfs@oss.sgi.com>; Wed,  8 Jan 2014 07:30:12 -0600 (CST)
Message-ID: <52CD52DF.8030509@sgi.com>
Date: Wed, 8 Jan 2014 07:30:07 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfstests: UDF support improvements
References: <1387839231-8558-1-git-send-email-jack@suse.cz>
In-Reply-To: <1387839231-8558-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

This series has been committed.

Thanks
--Rich

commit 7e4cac452bf38ee4ace80b60efca7f6318b88eea
Author: Jan Kara <jack@suse.cz>
Date:   Mon Dec 23 22:53:51 2013 +0000

     Add udf support into _scratch_mkfs_sized

commit 49684caded92f23dd18ec4698917e087f23a9016
Author: Jan Kara <jack@suse.cz>
Date:   Mon Dec 23 22:53:50 2013 +0000

     Fix output parsing in _check_udf_filesystem()


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
