Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 15:13:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBMNDPqw014719
	for <xfs@oss.sgi.com>; Fri, 22 Dec 2006 15:13:28 -0800
Message-ID: <458C6663.1050904@sandeen.net>
Date: Fri, 22 Dec 2006 17:12:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS
References: <BE7DD4DC7F4F024FA32FB6E94B73461A02BB3DE9@MAIL-NY.norwalk.medtechinc.com> <458C1917.4040807@falconstor.com>
In-Reply-To: <458C1917.4040807@falconstor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: geir.myrestrand@falconstor.com
Cc: Jaideep Nandy <jnandy@pbh-inc.com>, xfs@oss.sgi.com

Geir A. Myrestrand wrote:
> Jaideep Nandy wrote:
>> Usb drive. I used a tera station to format it with XFS and backed up
>> file onto it. Now I want to use the drive on a regular win xp box with 
>> ntfs partition.
> 
> Windows [XP] have no knowledge of XFS, nor have I ever heard of any 
> applications running natively on Windows [XP] that can read XFS file 
> systems. Your best bet is to use a Linux distro to read it.

you could also try http://www.crossmeta.com/crossmeta.html

> You can make your PC multi-boot, so that you either start up in Windows 
> XP or in Linux/UNIX.
> 
> You can also use a program like VMware Workstation or VMware Player 
> (both are free) to install Linux in a virtual machine under Windows 
> --then you can run both at the same time.
> 
> If you do not want to install anything, then get a Linux live distro and 
> boot from that. A live distro is a special DVD (or CD) that will let you 
> run the OS directly from the optical disc, with no need to install 
> anything on the local disk. You may need a USB drive or something like 
> that to save configuration files, etc.
> 
> Not all Linux distributions support XFS, but any version of SUSE Linux 
> should serve the purpose. OpenSUSE 10.2 was just released and should do 
> the job --see http://www.opensuse.org.
> 
> Once you get access to the XFS file system from Linux on your PC, then 
> you can copy it to a FAT partition, because both Windows and Linux 
> support that. Or you can access your NTFS partition from Linux (if you 
> dare) --see http://www.linux-ntfs.org.
> 
> I'm assuming that the USB drive is independent of the Tera Station, if 
> not then you can simply utilize the NAS feature of the Tera Station and 
> map to the share from Windows XP. Also, if you do not have the Tera 
> Station but have a Linux computer, then you could use Samba (see 
> http://www.samba.org) to share out the USB disk and you could map to it 
> from your Windows XP box.
> 
> With a closed source OS it isn't trivial for anyone to provide you with 
> direct support for a third party file system, it will be merely 
> workarounds for deficiencies in the OS.
> 
> I recommend you ditch your OS but keep your USB disk with XFS. ;-)
> 
> 
