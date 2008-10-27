Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Oct 2008 21:52:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9R4qWd1010776
	for <linux-xfs@oss.sgi.com>; Sun, 26 Oct 2008 21:52:32 -0700
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7907954990C
	for <linux-xfs@oss.sgi.com>; Sun, 26 Oct 2008 19:22:13 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com with ESMTP id Zoj99NHwOiA5t1mO for <linux-xfs@oss.sgi.com>; Sun, 26 Oct 2008 19:22:13 -0700 (PDT)
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KuHkA-000827-U3
	for linux-xfs@oss.sgi.com; Mon, 27 Oct 2008 02:22:11 +0000
Received: from 75-134-105-39.dhcp.aldl.mi.charter.com ([75.134.105.39])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 02:22:10 +0000
Received: from mlueck by 75-134-105-39.dhcp.aldl.mi.charter.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 02:22:10 +0000
From: Michael Lueck <mlueck@lueckdatasystems.com>
Subject: Re: Bad day with xfsrestore, what went wrong?
Date: Sun, 26 Oct 2008 22:22:03 -0400
Message-ID: <ge38k5$qf$1@ger.gmane.org>
References: <gde1k2$gkp$1@ger.gmane.org>
Reply-To: mlueck@lueckdatasystems.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <gde1k2$gkp$1@ger.gmane.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

No suggestions / possible answers anyone for my question...

Michael Lueck wrote:
> Greetings-
> 
> I hope this is the NNTP equiv of the email list found on this web page:
> http://oss.sgi.com/projects/xfs/
> 
> I have been using XFS with Debian for a number of years with great 
> success. Today, xfsrestore really threw me a curve ball. I am wondering 
> what went wrong.
> 
> I had wanted to restore from an old backup some directories that I 
> discovered I had need of. I used the following syntax to get the restore 
> started:
> 
> xfsrestore -J -E -f /mnt/ext_backup/ldslnx01/20061220/data -s shares/data -i -v verbose /srv
> 
> I selected some directories to restore through the interactive 
> interface, then allowed it to restore the specified files.
> 
> What it ended up doing, HOWEVER, was to restore every file present in 
> that old backup that was no longer on disk!
> 
> Thus, what went wrong?
> 
> Thanks!

-- 
Michael Lueck
Lueck Data Systems
http://www.lueckdatasystems.com/
