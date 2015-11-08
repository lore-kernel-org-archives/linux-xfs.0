Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8ECBF7F50
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 10:49:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BF24304032
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 08:49:46 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id K03yLopBaX7ss2FI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Nov 2015 08:49:43 -0800 (PST)
Date: Sun, 8 Nov 2015 08:49:41 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS freeze (xfsaild blocked) with 4.2.5 (also 4.3)
Message-ID: <20151108164941.GA26354@infradead.org>
References: <20151108114917.GA5620@achernar.madore.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151108114917.GA5620@achernar.madore.org>
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
To: David Madore <david+ml@madore.org>
Cc: Linux Kernel mailing-list <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi David,

can you try the patch at:

http://article.gmane.org/gmane.comp.file-systems.xfs.general/70984

The symptoms sound surprisingly similar.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
