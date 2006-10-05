Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 14:58:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k95LvsaG017912
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 14:57:55 -0700
Received: from zenon.apartia.fr (zenon.apartia.fr [82.66.93.83])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C77BFD17E096
	for <xfs@oss.sgi.com>; Thu,  5 Oct 2006 13:42:44 -0700 (PDT)
Received: from styx.apartia.fr (styx.apartia.fr [10.0.3.109])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "styx.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by zenon.apartia.fr (Postfix) with ESMTP id D9767F8C80631
	for <xfs@oss.sgi.com>; Thu,  5 Oct 2006 22:42:40 +0200 (CEST)
Date: Thu, 5 Oct 2006 22:42:40 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: is quotacheck fast with xfs?
Message-ID: <20061005204240.GA7922@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

We have a 500GB mail server with 200 users presently with reiserfs. At 
boot time quotacheck takes close to one hour.

Would quotacheck be faster on xfs?

Thanks,
