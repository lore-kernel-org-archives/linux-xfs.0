Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4BE107F9D
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:29:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12801304048
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:29:09 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id s0kfvKFkxiJQruy0 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:29:08 -0700 (PDT)
Date: Sun, 26 Jul 2015 09:29:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/4] xfsprogs: Use glibtoolize on osx
Message-ID: <20150726162907.GC16659@infradead.org>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
	<1437397018-12864-4-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1437397018-12864-4-git-send-email-jtulak@redhat.com>
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
Cc: xfs@oss.sgi.com

On Mon, Jul 20, 2015 at 02:56:57PM +0200, Jan Tulak wrote:
> OS X doesn't have libtoolize binary by default, and the available$
> ports are named "glibtoolize". Autodetect this issue.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
