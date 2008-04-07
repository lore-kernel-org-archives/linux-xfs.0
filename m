Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Apr 2008 05:52:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m37Cpx5L003294
	for <xfs@oss.sgi.com>; Mon, 7 Apr 2008 05:52:00 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72D2194EE29
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2008 05:52:37 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id mnxEFHs8ZaqoXsUU for <xfs@oss.sgi.com>; Mon, 07 Apr 2008 05:52:37 -0700 (PDT)
Date: Mon, 7 Apr 2008 08:52:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] fix lock inversion in forced unmount
Message-ID: <20080407125205.GC27350@infradead.org>
References: <20080402001758.GY103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402001758.GY103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Obviously correct.
