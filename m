Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 065987F58
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 01:58:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A16CBAC007
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 23:58:56 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id ddKLmoAzoNEtMRFC for
	<xfs@oss.sgi.com>; Tue, 30 Jul 2013 23:58:55 -0700 (PDT)
Message-ID: <51F8B5FF.2080903@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 15:00:15 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 4/7] xfs: convert kuid_t to/from uid_t for internal
	structures
References: <20130729230655.4bd762c6@oracle.com>
In-Reply-To: <20130729230655.4bd762c6@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On 07/30/2013 11:06 AM, Dwight Engen wrote:
> Use uint32 from init_user_ns for xfs internal uid/gid
> representation in xfs_icdinode, xfs_dqid_t.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---

Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
