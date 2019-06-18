Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54484 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbfFRQ30 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 12:29:26 -0400
Date: Tue, 18 Jun 2019 09:27:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: claim maintainership of loose files
Message-ID: <20190618162722.GC5387@magnolia>
References: <20190612154001.GC3773859@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612154001.GC3773859@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>

Ping?

On Wed, Jun 12, 2019 at 08:40:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Claim maintainership over the miscellaneous files outside of fs/xfs/
> that came from xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  MAINTAINERS |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 57f496cff999..f0edb53b9dd3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17357,7 +17357,13 @@ W:	http://xfs.org/
>  T:	git git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
>  S:	Supported
>  F:	Documentation/filesystems/xfs.txt
> +F:	Documentation/ABI/testing/sysfs-fs-xfs
> +F:	Documentation/filesystems/xfs.txt
> +F:	Documentation/filesystems/xfs-delayed-logging-design.txt
> +F:	Documentation/filesystems/xfs-self-describing-metadata.txt
>  F:	fs/xfs/
> +F:	include/uapi/linux/dqblk_xfs.h
> +F:	include/uapi/linux/fsmap.h
>  
>  XILINX AXI ETHERNET DRIVER
>  M:	Anirudha Sarangi <anirudh@xilinx.com>
