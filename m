Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF8A07FD3
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 09:58:08 -0600 (CST)
Message-ID: <5136157C.5080404@sgi.com>
Date: Tue, 5 Mar 2013 09:55:40 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: use right defrag program path
References: <1362147433-5788-1-git-send-email-wenqing.lz@taobao.com>
	<5130CDC1.8060704@redhat.com>
In-Reply-To: <5130CDC1.8060704@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Zheng Liu <wenqing.lz@taobao.com>

This patch has been committed.

commit 08557e219c12e573be459407033495899f46967a
Author: Zheng Liu <wenqing.lz@taobao.com>
Date:   Fri Mar 1 14:17:13 2013 +0000

     xfstests: use right defrag program path

     In _require_defrag defragmentation command path is fixed.  That will
     cause that this test case is skipped in some distributions.

     Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
