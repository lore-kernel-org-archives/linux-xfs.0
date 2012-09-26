Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8QKK8vg249908 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 15:20:08 -0500
Message-ID: <506363C1.7080500@sgi.com>
Date: Wed, 26 Sep 2012 15:21:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/6] xfs: add inode64->inode32 transition into
	xfs_set_inode32()
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
	<1348147961-7520-6-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1348147961-7520-6-git-send-email-cmaiolino@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 09/20/12 08:32, Carlos Maiolino wrote:
> To make inode32 a remountable option, xfs_set_inode32() should be able to make a
> transition from inode64 option, disabling inode allocation on higher AGs.
>
> Signed-off-by: Carlos Maiolino<cmaiolino@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
