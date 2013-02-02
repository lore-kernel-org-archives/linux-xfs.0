Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 991F37F51
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 18:03:00 -0600 (CST)
Date: Fri, 1 Feb 2013 18:02:56 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v4 00/13] xfs: kill hard-coded number 128 for
	transaction space log reservation
Message-ID: <20130202000256.GA27055@sgi.com>
References: <51067C33.6050900@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51067C33.6050900@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

Hey Jeff,

On Mon, Jan 28, 2013 at 09:25:07PM +0800, Jeff Liu wrote:
> There is only one minor fix in this round, please check the change log
> below.
> 
> Changes of v4 to v3:
> - xfs_trans_itruncate_reservation(): s/XFS_FSB_TO_B(mp, 0)/0/
> 
> Old patch sets:
> v3:
> http://www.spinics.net/lists/xfs/msg16165.html
> v2:
> http://www.spinics.net/lists/xfs/msg15917.html
> v1:
> http://www.spinics.net/lists/xfs/msg15499.html

Applied this series with the update patch #2.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
