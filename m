Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 19:39:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m642d4Ro004263
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 19:39:04 -0700
Received: from mx200i.civica.com.au (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 107C6DA21C9
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2008 19:40:06 -0700 (PDT)
Received: from mx200i.civica.com.au (mx200i.civica.com.au [203.56.2.222]) by cuda.sgi.com with ESMTP id n9jQRFspkQlo8uq9 for <xfs@oss.sgi.com>; Thu, 03 Jul 2008 19:40:06 -0700 (PDT)
Received: from gateway.civica.com.au (gateway.civica.com.au [10.61.100.12])
	by mx200i.civica.com.au (BorderWare MXtreme Mail Firewall) with ESMTP id CECE625897
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2008 12:40:05 +1000 (EST)
Subject: user defined cache
From: Warwick Boote <wboote@civica.com.au>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Jul 2008 12:40:05 +1000
Message-Id: <1215139205.7187.33.camel@quadski>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

Do you know of setting or layered file system that enables me to define
a large buffer in main memory and cache writes to this buffer?

Obviously i'd need the file system to also read from this buffer if the
data hasn't been flushed to the disk yet.


Waz.
=)




﻿(apologies for inappropriate disclaimer)


--

This email is from Civica Pty Limited and it, together with 
any attachments, is confidential to the intended recipient(s) 
and the contents may be legally privileged or contain 
proprietary and private information. It is intended solely 
for the person to whom it is addressed. If you are not an 
intended recipient, you may not review, copy or distribute 
this email. If received in error, please notify the sender 
and delete the message from your system immediately. Any 
views or opinions expressed in this email and any files 
transmitted with it are those of the author only and may 
not necessarily reflect the views of Civica and do not create 
any legally binding rights or obligations whatsoever. Unless 
otherwise pre-agreed by exchange of hard copy documents 
signed by duly authorised representatives, contracts may not 
be concluded on behalf of Civica by email. Please note that 
neither Civica nor the sender accepts any responsibility for 
any viruses and it is your responsibility to scan the email 
and the attachments (if any). All email received and sent by 
Civica may be monitored to protect the business interests of 
Civica. 
