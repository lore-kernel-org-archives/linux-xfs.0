Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E16CD7CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 18:40:21 -0500 (CDT)
Date: Tue, 30 Jul 2013 18:40:21 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v7 7/7] enable building user namespace with xfs
Message-ID: <20130730234021.GR3111@sgi.com>
References: <20130729230709.11033b2d@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130729230709.11033b2d@oracle.com>
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

Hey Dwight,

On Mon, Jul 29, 2013 at 11:07:09PM -0400, Dwight Engen wrote:
> >From e6a9ee0cfa0ed40484f66bc1726dc19de36038b8 Mon Sep 17 00:00:00 2001
> From: Dwight Engen <dwight.engen@oracle.com>
> Date: Tue, 2 Jul 2013 09:52:54 -0400
> Subject: [PATCH 7/7] enable building user namespace with xfs
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>

Was there a patch running around to limit bulkstat to init_user_ns?  Any other
items that needed to be addressed before applying this patch?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
