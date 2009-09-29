Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8TCpQga204822 for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 07:51:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CA1F489DFF
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 05:52:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id NVF4m7qXRZXhQwBd for
	<xfs@oss.sgi.com>; Tue, 29 Sep 2009 05:52:48 -0700 (PDT)
Date: Tue, 29 Sep 2009 08:52:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS Question
Message-ID: <20090929125246.GB11375@infradead.org>
References: <E87DB458899A9040ACD4D627073D9EF606028EAC@VFOHMLAO11.Enterprise.afmc.ds.af.mil>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E87DB458899A9040ACD4D627073D9EF606028EAC@VFOHMLAO11.Enterprise.afmc.ds.af.mil>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Shue, David CTR USAF AFMC AFRL/RITB" <David.Shue.ctr@rl.af.mil>
Cc: xfs@oss.sgi.com

On Tue, Sep 29, 2009 at 08:21:47AM -0400, Shue, David CTR USAF AFMC AFRL/RITB wrote:
> Kernel-module-xfs-#####
> 
> Xfsprogs-####
> 
> Xfsprogs-devel-####
> 
>  
> 
> My question is, I will perform the system update, but what will happen
> to my XFS system?  Do I simply locate the above three RPM's for the
> latest kernel I am installing and be good to go?  

RHEL5.4 includes a xfs module which will be as unsupported as your
current configuration.  You can keep the userspace RPMs as-is.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
