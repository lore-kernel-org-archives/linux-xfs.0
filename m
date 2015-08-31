Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 58ED17F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 13:59:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CA9E304032
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 11:59:46 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Or06k4A3sGMVbXmS (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 11:59:45 -0700 (PDT)
Date: Mon, 31 Aug 2015 11:59:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/11] xfsprogs: add nftw64 translation for OS X
Message-ID: <20150831185944.GI349@infradead.org>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-7-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1440590555-20463-7-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Wed, Aug 26, 2015 at 02:02:31PM +0200, Jan Tulak wrote:
> OS X has only nftw variant - not the 64 suffix used in xfs.

Can you just use a #define?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
