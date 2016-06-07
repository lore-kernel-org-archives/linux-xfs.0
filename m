Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5D0217CA0
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 02:51:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2DF06304043
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 00:51:40 -0700 (PDT)
Received: from hotel311.server4you.de (hotel311.server4you.de [85.25.146.15])
	by cuda.sgi.com with ESMTP id itoCgL5bFFycl45i (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2016 00:51:36 -0700 (PDT)
Subject: Re: crash in xfs in current
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
From: Daniel Wagner <wagi@monom.org>
Message-ID: <c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
Date: Tue, 7 Jun 2016 09:51:34 +0200
MIME-Version: 1.0
In-Reply-To: <20160607062717.GA30022@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, reinoudkoornstra@gmail.com
Cc: viro@zeniv.linux.org.uk, xfs@oss.sgi.com

> Given that 4.7-rc1 comes with the new shared locks for lookups, and
> there are very little other changes I wonder if there is any relation
> It would be good if Reinoud and/or Daniel can confirm that Linux 4.6
> is ok.

I try to reproduce it on 4.6. My steps do not always trigger the crash.
So I can't be really sure if 4.6 doesn't show it, it does not happen.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
