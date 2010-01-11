Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BLa09f180823 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 15:36:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97237EF7192
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 13:36:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wInVad2bUj0YM3KU for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 13:36:54 -0800 (PST)
Date: Mon, 11 Jan 2010 16:36:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3] mkfs: handle 4k sector devices more cleanly
Message-ID: <20100111213652.GA30724@infradead.org>
References: <4B1E9A25.50108@redhat.com> <4B476171.4020701@sandeen.net>
	<4B4B6990.8090604@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B4B6990.8090604@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
