Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F9BE29E18
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 09:11:38 -0600 (CST)
Message-ID: <52A880A7.2000209@sgi.com>
Date: Wed, 11 Dec 2013 09:11:35 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] generic: require filesize to be greater than fs block
	size in generic/240
References: <1386760888-30022-1-git-send-email-stanislav.kholmanskikh@oracle.com>
In-Reply-To: <1386760888-30022-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>, xfs@oss.sgi.com
Cc: vasily.isaenko@oracle.com, hch@infradead.org

This has been committed.

Thanks
--Rich

commit 43fb49332d0f810c843dc01327b3ca203e997ae7
Author: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Date:   Wed Dec 11 11:21:28 2013 +0000

     generic: require filesize to be greater than fs block size in

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
