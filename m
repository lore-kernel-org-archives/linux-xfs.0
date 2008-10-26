Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 13:36:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9QKZYqa027705
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:35:35 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91BB9148676B
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:35:35 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id fsEPyfxAfLbe2jrk for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:35:35 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuCKl-0002SJ-75
	for xfs@oss.sgi.com; Sun, 26 Oct 2008 20:35:35 +0000
Date: Sun, 26 Oct 2008 16:35:35 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/6] inode location mapping refactoring
Message-ID: <20081026203535.GT4173@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Refactor the inode to buffer mapping infrastructure.

-- 
