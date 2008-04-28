Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 20:51:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3S3opu1028787
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 20:50:59 -0700
Date: Sun, 27 Apr 2008 23:51:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Message-ID: <20080428035133.GB14275@infradead.org>
References: <200804270246.58828.vda.linux@googlemail.com> <20080427232317.GB103491721@sgi.com> <200804280148.22358.vda.linux@googlemail.com> <20080428023757.GB108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428023757.GB108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

Note that I'm happy to revisit and test patches by others if they are
useful enough.  Please add me to the CC list in that case.
