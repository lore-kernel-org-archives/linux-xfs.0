Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBAEY5wX008575 for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 08:34:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D29D316102D4
	for <xfs@oss.sgi.com>; Fri, 10 Dec 2010 06:35:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id no34PHDiQFd7dlrR for
	<xfs@oss.sgi.com>; Fri, 10 Dec 2010 06:35:55 -0800 (PST)
Date: Fri, 10 Dec 2010 09:35:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests: ignore absolute address in filename in test case 237
Message-ID: <20101210143554.GA1415@infradead.org>
References: <1291899944.3196.11.camel@dhcp-31-190.brq.redhat.com>
	<1291902047.3196.26.camel@dhcp-31-190.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1291902047.3196.26.camel@dhcp-31-190.brq.redhat.com>
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
To: Boris Ranto <branto@redhat.com>
Cc: xfs@oss.sgi.com

I don't mind the patch, but what version of getfacl would produce an
absolute filename?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
