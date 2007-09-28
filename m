Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 09:48:31 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8SGmOiI028354
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 09:48:27 -0700
Message-ID: <46FD3054.9060803@thebarn.com>
Date: Fri, 28 Sep 2007 11:48:20 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: kernel 2.6.9-42ELsmp
References: <cce360c30709272255h411c368foa07c831a68ce537a@mail.gmail.com>
In-Reply-To: <cce360c30709272255h411c368foa07c831a68ce537a@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010607070702050807050907"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Manoj Kumar Pradhan <manojkp80@gmail.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------010607070702050807050907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Manoj Kumar Pradhan wrote:
> Hi,
>
> I am trying to build my RH kernel for XFS dmapi support. I learnt from your
> site that the correct kernel can be cvs checkout from oss.sgi.com. I tried
> the procedure indicated there to do so, but i cant login to ':
> psrever:cvs@oss.sgi.com:/cvs' with password "cvs". It says connection timed
>   
> out.
>   
Check your CVSROOT agin... the above line is not correct.
http://oss.sgi.com/projects/xfs/source.html
> Is there any other way to get the kernel?
> Also I learnt that XFS dmapi is not supported on RHEL4, is it?
> Is there any list of RHEL kernel releases which can support XFS with DMAPI
> on x86_64 platforms?
>   

The cvs tree on oss is not a rhel4 tree tho, it is a current linux 
release + latest xfs and kdb
> Thanks,
> Manoj
>
>
> [[HTML alternate version deleted]]
>
>   


--------------010607070702050807050907
Content-Type: text/x-vcard; charset=utf-8;
 name="cattelan.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cattelan.vcf"

begin:vcard
fn:Russell Cattelan
n:Cattelan;Russell
email;internet:cattelan@thebarn.com
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------010607070702050807050907--
