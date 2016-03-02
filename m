Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2898E7CB4
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 09:47:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8DD25AC004
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 07:47:39 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id VUazvK9uQf8e7JUa (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 07:47:32 -0800 (PST)
Date: Wed, 2 Mar 2016 07:47:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: tidy up xfs_attr_shortform_list
Message-ID: <20160302154732.GA7125@infradead.org>
References: <1456932511-19305-1-git-send-email-mguzik@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456932511-19305-1-git-send-email-mguzik@redhat.com>
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
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Mar 02, 2016 at 04:28:31PM +0100, Mateusz Guzik wrote:
> Remove an unnecessary i == nsbuf test and replace a common label for error
> handling after sbuf is allocated.
> 
> Signed-off-by: Mateusz Guzik <mguzik@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
