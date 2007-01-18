Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Jan 2007 02:36:45 -0800 (PST)
Received: from poster.science.ru.nl (poster.science.ru.nl [131.174.30.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0IAabqw028340
	for <linux-xfs@oss.sgi.com>; Thu, 18 Jan 2007 02:36:39 -0800
Received: from smeltpunt.science.ru.nl [131.174.16.145]  (helo=smeltpunt.science.ru.nl)
	by poster.science.ru.nl (8.13.7/5.11) with ESMTP id l0IALHRS003751
	for <linux-xfs@oss.sgi.com>; Thu, 18 Jan 2007 11:21:17 +0100 (MET)
Received: from brielle.hef.kun.nl [131.174.192.149]  (helo=[131.174.192.149])
	by smeltpunt.science.ru.nl (8.13.7/5.11) with ESMTP id l0IALC22024507
	for <linux-xfs@oss.sgi.com>; Thu, 18 Jan 2007 11:21:12 +0100 (MET)
Message-ID: <45AF4A1A.50805@science.ru.nl>
Date: Thu, 18 Jan 2007 11:21:14 +0100
From: Wim Janssen <WGHM.Janssen@science.ru.nl>
MIME-Version: 1.0
Subject: xfs-questions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello Folks,

Yesterday I downloaded from the SGI-ftpsite the module:
       kernel-module-xfs-2.6.9-22.EL-0.1-1.src.rpm
This because I like to work with the xfs-filesystem on my storage-unit.
 ( a Dell PowerEdge1950 with a MD1000-diskarray )
As Eric pointed out in the readme-file he tested it a bit with the 
2.6.9-22 kernel
and it might also work with other RHEL kernels.
On my storage-unit I installed the 64-bit RHEL4 AS with the kernel:
   2.6.9-42.ELsmp  x86_64

My questions:
- If I install the xfs-module, how can I test that it is working 
properly ???
- How can I be sure about the stability ???
  Do you have some test about this ???
- Does a more recent version of the module exists ???
- How do I have to deal with the kernel-updates I get from RedHat ???
- Can you give me some hints/advice how to proceed and avoid difficulties.
  Because the storage-unit is going to be a very critical part of our 
IT-infra-structure.

For many years I have worked with the xfs-filesystem on the SGI Indigo- and
Challenge-systems and was always very pleased with the stability, 
performance
and managability. That's why I consider to implement the xfs-filesystem 
for our storage-unit.
I hope you can help me with my questions.

Kind regards and many thanks in advance,

                                                                         
                                   Wim Janssen
P.S.
It would be nice if I can report a success in the neaar future.

-- 
 Radboud Universiteit Nijmegen  Phone: +31(0)24-3652097  [ Wim Janssen ]
 Hoge Energie Fysica              Fax: +31(0)24-3652191   Systeembeheer        
 Toernooiveld 1            E-mail: W.Janssen@hef.ru.nl
 6525 ED  Nijmegen            URL: http://www.hef.ru.nl
