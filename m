Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 08:39:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2JFdam3018307
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 08:39:38 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDBFA6BE084
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 08:40:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id AgvHKGjszINpQCBu for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 08:40:08 -0700 (PDT)
Message-ID: <47E133D6.4080204@sandeen.net>
Date: Wed, 19 Mar 2008 10:40:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <b1b17e290803181649w507322e7mf1410b30a2621506@mail.gmail.com> <20080319002307.GA11349@josefsipek.net> <47E0F746.1090508@ventoso.org> <47E10CBA.9020904@sandeen.net> <47E11F4A.3090205@ventoso.org> <47E12D20.4010901@sandeen.net> <47E132A0.8030000@ventoso.org>
In-Reply-To: <47E132A0.8030000@ventoso.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Luca Olivetti <luca@ventoso.org>
Cc: xfs@oss.sgi.com

Luca Olivetti wrote:

>> Can you try the same steps on your box?
> 
> I'll report your result on the nas-central.org forum and I'll check 
> what's the status of 2.6.25-rc2 on the linkstation (though I see that 
> the orion.git repository is only updated to rc1).
> If I find that it's possible to boot this kernel with no (or little ;-) 
> risk I'll try it.

You might also try that same image on your older kernel, to be sure the
test is valid (i.e., my test sequence still breaks for you on the old
kernel).

-Eric
