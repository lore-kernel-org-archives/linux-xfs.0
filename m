Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 762BC7CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 09:47:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 39F9730404E
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 07:47:29 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rdr1NomlLWiV4eeK (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 May 2016 07:47:27 -0700 (PDT)
Date: Thu, 12 May 2016 07:47:26 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 1/2] libxcmd: generalize topology functions
Message-ID: <20160512144726.GA5611@infradead.org>
References: <1463006717-6104-1-git-send-email-billodo@redhat.com>
	<1463006717-6104-2-git-send-email-billodo@redhat.com>
	<20160512115513.GD32528@infradead.org>
	<20160512122039.GA19699@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160512122039.GA19699@redhat.com>
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
To: Bill O'Donnell <billodo@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, May 12, 2016 at 07:20:39AM -0500, Bill O'Donnell wrote:
> xfs_multidisk.h came about a few days ago (4a32b9e928b80)
> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

Gah, looks like I'm stuck on the oss.sgi.com repo..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
