Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3F27E7F5A
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 02:08:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D034AAC003
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 00:08:28 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 2J1cQXO5179Iuyu9 for
	<xfs@oss.sgi.com>; Wed, 31 Jul 2013 00:08:27 -0700 (PDT)
Message-ID: <51F8B83A.60100@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 15:09:46 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 5/7] xfs: create internal eofblocks structure with
	kuid_t types
References: <20130729230700.6d07bf73@oracle.com>
In-Reply-To: <20130729230700.6d07bf73@oracle.com>
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

On 07/30/2013 11:07 AM, Dwight Engen wrote:
> Have eofblocks ioctl convert uid_t to kuid_t into internal structure.
> Update internal filter matching to compare ids with kuid_t types.
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---

Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
