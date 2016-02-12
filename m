Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3F3AB7F47
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 13:39:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C305304048
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:39:43 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id S1tzTLkuFjb7oO0R (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:39:42 -0800 (PST)
Date: Fri, 12 Feb 2016 11:39:42 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 1/2] libxcmd: generalize topology functions
Message-ID: <20160212193942.GA4770@infradead.org>
References: <1455303811-9874-1-git-send-email-billodo@redhat.com>
	<1455303811-9874-2-git-send-email-billodo@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455303811-9874-2-git-send-email-billodo@redhat.com>
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
Cc: xfs@oss.sgi.com

On Fri, Feb 12, 2016 at 01:03:30PM -0600, Bill O'Donnell wrote:
> Move general topology functions from xfs_mkfs to new topology
> collection in libxcmd.

Why libxcmd and not libxfs?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
