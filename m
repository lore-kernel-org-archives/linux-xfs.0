Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94AA17CA0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 12:38:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4ABC58F8033
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:38:06 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id eo9MTP0Ej9qBgqwJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:38:05 -0700 (PDT)
Date: Thu, 18 Aug 2016 10:38:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 xfsprogs 03/14] remove unecessary definitions of
	_FILE_OFFSET_BITS
Message-ID: <20160818173804.GC27799@infradead.org>
References: <cover.1471107858.git.felix.janda@posteo.de>
	<3dc24ff681ee0f831f2902bdb800547f0b63a30e.1471107858.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3dc24ff681ee0f831f2902bdb800547f0b63a30e.1471107858.git.felix.janda@posteo.de>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Sun, Aug 07, 2016 at 07:28:16AM +0200, Felix Janda wrote:
> now that we use AC_SYS_LARGEFILE, there is no need to explicitly
> define _FILE_OFFSET_BITS.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
