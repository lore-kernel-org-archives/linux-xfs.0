Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 13:34:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9QKYijv027122
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:44 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BE34546F32
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id v54vk6seGRZz8rIE for <xfs@oss.sgi.com>; Sun, 26 Oct 2008 13:34:44 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuCJw-0001fD-DM
	for xfs@oss.sgi.com; Sun, 26 Oct 2008 20:34:44 +0000
Date: Sun, 26 Oct 2008 16:34:44 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/3] Sync refactoring fallout
Message-ID: <20081026203444.GD4173@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This series gets rid of two headers left more or less useless after the
last round of sync patches.

-- 
