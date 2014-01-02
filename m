Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1234529DF8
	for <xfs@oss.sgi.com>; Thu,  2 Jan 2014 07:21:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88FC8AC003
	for <xfs@oss.sgi.com>; Thu,  2 Jan 2014 05:21:00 -0800 (PST)
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	w96qbpI1iDiQDTqG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Jan 2014 05:20:59 -0800 (PST)
Received: by mail-ie0-f169.google.com with SMTP id e14so14818041iej.28
	for <xfs@oss.sgi.com>; Thu, 02 Jan 2014 05:20:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201401021304.s02D4Agc028655@m2c-new.corp.sgi.com>
References: <201401021304.s02D4Agc028655@m2c-new.corp.sgi.com>
Date: Thu, 2 Jan 2014 15:20:58 +0200
Message-ID: <CA+apj_j6OMM7he1eP_fkZ5jGT6ag5mPVE8Lk-G6S--0kUmzcgg@mail.gmail.com>
Subject: Re: XFS File System Monitor
From: Rotem Ben Arye <rotem.benarye@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4986813398432691469=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: support@sgi.com
Cc: xfs@oss.sgi.com

--===============4986813398432691469==
Content-Type: multipart/alternative; boundary=001a11c2f8ba0d1a7604eefcaacf

--001a11c2f8ba0d1a7604eefcaacf
Content-Type: text/plain; charset=ISO-8859-1

HI , I'm not sure it will help here,  we  are working central storage with
Netapp , EMC and others ,
The Using of XFS File system on volume , is expressed with an creation of
XFS, as e.g :  mkfs.xfs.
 My question about what are the tools that could assist us to monitor XFS
file system was in general.


 On Thu, Jan 2, 2014 at 3:04 PM, <support@sgi.com> wrote:

> Hello Rotem
>
> We have received your email and wish to log your request. However we need
> to know the Serial Number (s/n) of your machine in order to do so.
>
> The Serial Number is usually located on a white barcode label on the back
> of your machine.
>
> Depending on your system type, you may also be able to determine the
> serial number by running one of the following commands:
>
> 1) "sysinfo -vv" (Irix)
> 2) "cat /proc/sgi_sn/system_serial_number" (Altix)
> 3) dmidecode |grep Serial |grep X  (Altix XE)
> 4) scash -p -c "dmidecode |grep Serial |grep X" (Altix XE Clusters with
> Scalimanage)
> 5) dmidecode  | grep "Serial Number" | grep Z (Altix ICE)
> 6) dmidecode -s system-serial-number (Altix UV 10)
> 7) From the OS, use the 'topology' command.  From the SMN, use the
> 'config' command.  (Altix UV 100 & UV 1000)
> 8) "wmic bios get serialnumber" from the command line (Windows 2003/2008)
>
> Once we receive this information, we will be able to log a case.
>
> Thank you in advance.
>
> Regards,
> SGI Global Customer Support Center
>
> Corporate Office:
> SGI, 46600 Landing Parkway, Fremont, CA 94538, USA
>
> >
> >
> > To: support@sgi.com
> > Date: 12:16 PM Thursday January 02nd, 2014(GMT)
> > From: "Rotem Ben Arye" <rotem.benarye@gmail.com>
> > CC: xfs@oss.sgi.com
> > Subject: XFS File System Monitor
> >
> > Hi, SGI Support Team.
> >
> > My Name is Rotem , I am a Linux/Unix System Administrator in web company
> > at Israel. I have a question I want to appeal to you to get some advice.
> >
> > In the last weekend we had crisis in one of the Production server in
> > the comany ,the problem was defined by the Integrators as  "xfs file
> > system corrupted"
> >
> > My question is , what are the open source tools , that we can use on
> > runtime at production environment , to monitor and sample to get
> > indication on mount XFS , That something is not living well, and can
> > lead to problem.
> >
> > We are working in a Linux environment on CentOS distributions server.
> >
> > Thank you,
> >
> > Rotem Ben Arye
> >
>
>
> -------------------------------------------------------------------------------
> ***** Have you tried Supportfolio? *****
> Did you know that you can open cases via the SGI web portal Supportfolio?
>  Just click on the following link: https://support.sgi.com/login
>
> -------------------------------------------------------------------------------
>
> http://www.sgi.com/
> Contact us: http://www.sgi.com/support/supportcenters.html
>
> NB: Information in this message is SGI confidential. It is intended solely
> for the person(s) to whom it is addressed and may not be copied, used,
> disclosed or distributed to others without SGI consent. If you are not the
> intended recipient please will you notify me by email or telephone, delete
> the message from your system immediately and destroy any printed copies.
>
>

--001a11c2f8ba0d1a7604eefcaacf
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>HI , I&#39;m not sure it will help here,=A0 we=
=A0 are working central storage=A0with Netapp , EMC and others ,=A0 <br>The=
 Using of XFS File system on volume=A0, is expressed with an creation of XF=
S, as e.g :=A0 mkfs.xfs.<br>
=A0My question about what are the tools that could assist us to monitor XFS=
 file system was in general.</div><div class=3D"gmail_extra">=A0</div><div =
class=3D"gmail_extra"><br>=A0On Thu, Jan 2, 2014 at 3:04 PM,  <span dir=3D"=
ltr">&lt;<a href=3D"mailto:support@sgi.com" target=3D"_blank">support@sgi.c=
om</a>&gt;</span> wrote:<br>
</div></div><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blockquo=
te class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;padding-left:1ex=
;border-left-color:rgb(204,204,204);border-left-width:1px;border-left-style=
:solid">
Hello Rotem<br>
<br>
We have received your email and wish to log your request. However we need t=
o know the Serial Number (s/n) of your machine in order to do so.<br>
<br>
The Serial Number is usually located on a white barcode label on the back o=
f your machine.<br>
<br>
Depending on your system type, you may also be able to determine the serial=
 number by running one of the following commands:<br>
<br>
1) &quot;sysinfo -vv&quot; (Irix)<br>
2) &quot;cat /proc/sgi_sn/system_serial_number&quot; (Altix)<br>
3) dmidecode |grep Serial |grep X =A0(Altix XE)<br>
4) scash -p -c &quot;dmidecode |grep Serial |grep X&quot; (Altix XE Cluster=
s with Scalimanage)<br>
5) dmidecode =A0| grep &quot;Serial Number&quot; | grep Z (Altix ICE)<br>
6) dmidecode -s system-serial-number (Altix UV 10)<br>
7) From the OS, use the &#39;topology&#39; command. =A0From the SMN, use th=
e &#39;config&#39; command. =A0(Altix UV 100 &amp; UV 1000)<br>
8) &quot;wmic bios get serialnumber&quot; from the command line (Windows 20=
03/2008)<br>
<br>
Once we receive this information, we will be able to log a case.<br>
<br>
Thank you in advance.<br>
<br>
Regards,<br>
SGI Global Customer Support Center<br>
<br>
Corporate Office:<br>
SGI, 46600 Landing Parkway, Fremont, CA 94538, USA<br>
<br>
&gt;<br>
&gt;<br>
&gt; To: <a href=3D"mailto:support@sgi.com">support@sgi.com</a><br>
&gt; Date: 12:16 PM Thursday January 02nd, 2014(GMT)<br>
&gt; From: &quot;Rotem Ben Arye&quot; &lt;<a href=3D"mailto:rotem.benarye@g=
mail.com">rotem.benarye@gmail.com</a>&gt;<br>
&gt; CC: <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; Subject: XFS File System Monitor<br>
<div><div class=3D"h5">&gt;<br>
&gt; Hi, SGI Support Team.<br>
&gt;<br>
&gt; My Name is Rotem , I am a Linux/Unix System Administrator in web compa=
ny<br>
&gt; at Israel. I have a question I want to appeal to you to get some advic=
e.<br>
&gt;<br>
&gt; In the last weekend we had crisis in one of the Production server in<b=
r>
&gt; the comany ,the problem was defined by the Integrators as =A0&quot;xfs=
 file<br>
&gt; system corrupted&quot;<br>
&gt;<br>
&gt; My question is , what are the open source tools , that we can use on<b=
r>
&gt; runtime at production environment , to monitor and sample to get<br>
&gt; indication on mount XFS , That something is not living well, and can<b=
r>
&gt; lead to problem.<br>
&gt;<br>
&gt; We are working in a Linux environment on CentOS distributions server.<=
br>
&gt;<br>
&gt; Thank you,<br>
&gt;<br>
&gt; Rotem Ben Arye<br>
&gt;<br>
<br>
</div></div>---------------------------------------------------------------=
----------------<br>
***** Have you tried Supportfolio? *****<br>
Did you know that you can open cases via the SGI web portal Supportfolio? =
=A0Just click on the following link: <a href=3D"https://support.sgi.com/log=
in" target=3D"_blank">https://support.sgi.com/login</a><br>
---------------------------------------------------------------------------=
----<br>
<br>
<a href=3D"http://www.sgi.com/" target=3D"_blank">http://www.sgi.com/</a><b=
r>
Contact us: <a href=3D"http://www.sgi.com/support/supportcenters.html" targ=
et=3D"_blank">http://www.sgi.com/support/supportcenters.html</a><br>
<br>
NB: Information in this message is SGI confidential. It is intended solely =
for the person(s) to whom it is addressed and may not be copied, used, disc=
losed or distributed to others without SGI consent. If you are not the inte=
nded recipient please will you notify me by email or telephone, delete the =
message from your system immediately and destroy any printed copies.<br>

<br>
</blockquote></div><br></div></div>

--001a11c2f8ba0d1a7604eefcaacf--


--===============4986813398432691469==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4986813398432691469==--
