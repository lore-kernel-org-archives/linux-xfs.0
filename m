Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43HTr53022452 for <xfs@oss.sgi.com>; Tue, 3 May 2011 12:29:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5539F11C93C7
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 10:33:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YwI3seKiYACXypBH for
	<xfs@oss.sgi.com>; Tue, 03 May 2011 10:33:28 -0700 (PDT)
Date: Tue, 3 May 2011 13:33:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsprogs: fixes a regression hang in xfs_repair phase 4
Message-ID: <20110503173325.GA13209@infradead.org>
References: <BANLkTikBSadR7K2RfiS2k60nEOPncaDfyw@mail.gmail.com>
	<20110422065120.GB14189@infradead.org>
	<BANLkTi=3V0TohK6c6MYOvPQc3ADd_Pya3A@mail.gmail.com>
	<BANLkTinfqmqPTuLFDW_jv_Dn4jNsP5gLcQ@mail.gmail.com>
	<BANLkTinx_DF=cgY9um=h_0z+gC3fDakoUw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTinx_DF=cgY9um=h_0z+gC3fDakoUw@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, May 02, 2011 at 11:09:32AM +0530, Ajeet Yadav wrote:
> It will be fine for me, if you have received the xfs_metadump file I
> sent in last mail.
> I am sure it will help you find problem in repair btree, please
> correct me if I left you anything from my side.

Yes, got it.  I'll apply your patch shortly.

Thanks a lot!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
