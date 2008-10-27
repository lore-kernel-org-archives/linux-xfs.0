Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:41:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDfJxV024560
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:19 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A63AADE70A
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id vNpITqAC4xn6AR03 for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:41:18 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSLO-0000pT-Jw
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:41:18 +0000
Date: Mon, 27 Oct 2008 09:41:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/6] inode location mapping refactoring
Message-ID: <20081027134118.GA3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Refactor the inode to buffer mapping infrastructure.

-- 
