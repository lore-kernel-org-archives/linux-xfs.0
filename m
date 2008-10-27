Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:03:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RD3AnQ017981
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:03:11 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E30E612AD8FF
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:03:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id v07Vw5xZmaFsbaR1 for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:03:09 -0700 (PDT)
Date: Mon, 27 Oct 2008 09:03:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] Add error handling of write_super_lockfs/unlockfs
Message-ID: <20081027130259.GA1919@infradead.org>
References: <20081027215832t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027215832t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Looks good.
